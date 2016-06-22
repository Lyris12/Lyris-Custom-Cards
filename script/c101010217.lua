--Ragna Clarissa of Stellar Vine
local id,ref=GIR()
function ref.start(c)
	--grave > remove
	local ae1=Effect.CreateEffect(c)
	ae1:SetCategory(CATEGORY_REMOVE)
	ae1:SetType(EFFECT_TYPE_QUICK_O)
	ae1:SetCode(EVENT_FREE_CHAIN)
	ae1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ae1:SetRange(LOCATION_MZONE)
	ae1:SetCountLimit(1,id)
	ae1:SetLabel(LOCATION_GRAVE)
	ae1:SetCondition(ref.con)
	ae1:SetTarget(ref.tg1)
	ae1:SetOperation(ref.op1)
	c:RegisterEffect(ae1)
	--grave < remove
	local ae2=Effect.CreateEffect(c)
	ae2:SetType(EFFECT_TYPE_QUICK_O)
	ae2:SetCode(EVENT_FREE_CHAIN)
	ae2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ae2:SetRange(LOCATION_MZONE)
	ae2:SetCountLimit(1,id)
	ae2:SetLabel(LOCATION_REMOVED)
	ae2:SetCondition(ref.con)
	ae2:SetTarget(ref.tg2)
	ae2:SetOperation(ref.op2)
	c:RegisterEffect(ae2)
	--refill
	local ae3=Effect.CreateEffect(c)
	ae3:SetCategory(CATEGORY_REMOVE)
	ae3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	ae3:SetCode(EVENT_TO_GRAVE)
	ae3:SetRange(LOCATION_MZONE)
	ae3:SetCountLimit(1)
	ae3:SetCondition(ref.condition)
	ae3:SetTarget(ref.target)
	ae3:SetOperation(ref.operation)
	c:RegisterEffect(ae3)
	if not ref.global_check then
		ref.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(ref.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
ref.spatial=true
--Spatial Formula filter(s)
ref.material1=function(mc) return c:IsSetCard(0x785e) and c:GetLevel()>0 end
ref.material2=function(mc) return c:IsAttribute(ATTRIBUTE_WATER) end -- Invert this block of code on Division Spatial Monsters (begin)
ref.subt_spatial=true
-- ref.divs_spatial=true --Division Procedure /
-- ref.stat=function(mc) return mc:GetAttack() or mc:GetDefence() or mc:GetAttack()-mc:GetDefence() end
-- ref.indicator=function(mc) return mc:GetLevel() or mc:GetRank() end -- Invert this block of code on Division Spatial Monsters (end)
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,450)
	Duel.CreateToken(1-tp,450)
end
function ref.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x785e)
end
function ref.con(e,tp,eg,ep,ev,re,r,rp)
	local loc1=e:GetLabel()
	local loc2=0x30-loc1
	return Duel.GetMatchingGroupCount(ref.cfilter,tp,loc1,0,nil)>Duel.GetMatchingGroupCount(ref.cfilter,tp,loc2,0,nil)
end
function ref.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function ref.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(ref.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil,e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:GetCount()>1 and Duel.IsExistingMatchingCard(ref.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,mg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=mg:Select(tp,2,2,nil)
	Duel.SetTargetCard(sg1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function ref.filter(c,e,tp)
	return c:IsSetCard(0x785e) and c:IsCanBeEffectTarget(e)
end
function ref.xyzfilter(c,mg)
	return c:IsAttribute(ATTRIBUTE_WATER) and (c:IsSetCard(0x785e) or (c.xyz_count==2 and c:IsXyzSummonable(mg)))
end
function ref.mfilter1(c,exg)
	return exg:IsExists(ref.mfilter2,1,nil,c)
end
function ref.mfilter2(c,mc)
	return c.xyz_filter(mc)
end
function ref.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ct1=Duel.GetMatchingGroupCount(ref.cfilter,tp,LOCATION_GRAVE,0,nil)
	local ct2=Duel.GetMatchingGroupCount(ref.cfilter,tp,LOCATION_REMOVED,0,nil)
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and ct1>ct2 then
		local ct=ct1-ct2
		local g=Duel.GetDecktopGroup(tp,ct)
		g:Merge(Duel.GetDecktopGroup(1-tp,ct))
		Duel.DisableShuffleCheck()
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function ref.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()<2 then return end
	local xyzg=Duel.GetMatchingGroup(ref.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		if xyz:IsSetCard(0x785e) then
			Duel.SpecialSummon(xyz,SUMMON_TYPE_XYZ+7150,tp,tp,false,false,POS_FACEUP)
			local atk=0
			local def=0
			local rg=g:GetFirst()
			while rg do
				local atk1=rg:GetAttack()
				local atk2=rg:GetDefence()
				atk=atk+atk1
				def=def+atk2
				rg=g:GetNext()
			end
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_BASE_ATTACK)
			e2:SetValue(atk)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			xyz:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_SET_BASE_DEFENCE)
			e3:SetValue(def)
			xyz:RegisterEffect(e3)
		elseif xyz:IsXyzSummonable(g) then
			Duel.XyzSummon(tp,xyz,g)
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		xyz:RegisterEffect(e1)
	end
end
