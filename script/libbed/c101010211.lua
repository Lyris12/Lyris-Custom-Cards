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
	ae1:SetCountLimit(1,101010601)
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
	ae2:SetCountLimit(1,101010601)
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
	--special summon (Do Not Remove)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(ref.spcon)
	e1:SetOperation(ref.spop)
	e1:SetValue(SUMMON_TYPE_XYZ+7150)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(function(e,se,ep,st) return bit.band(st,SUMMON_TYPE_XYZ+7150)==SUMMON_TYPE_XYZ+7150 end)
	c:RegisterEffect(e2)
	--cannot Grave (Do Not Remove)
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD)
	ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_RANGE)
	ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	ge1:SetTargetRange(LOCATION_ONFIELD+LOCATION_OVERLAY,0)
	ge1:SetTarget(function(e,c) return c==e:GetHandler() end)
	ge1:SetValue(LOCATION_REMOVED)
	Duel.RegisterEffect(ge1,0)
end
function ref.sfilter1(c,x,g)
	local lv=c:GetLevel()
	local rk=c:GetRank()
	return g:IsExists(ref.sfilter2,1,c,x,lv,rk)
end
function ref.sfilter2(c,x,lv,rk)
	return math.abs(c:GetLevel()-lv==x) or math.abs(c:GetLevel()-rk)==x
end
function ref.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-1 then return end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(ref.sfilter1,1,nil,4,g)
end
function ref.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Group.CreateGroup()
	local x=4
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc1=g:FilterSelect(tp,ref.sfilter1,1,1,nil,x,g):GetFirst()
	mg:AddCard(tc1)
	local tc2=g:FilterSelect(tp,ref.sfilter2,1,1,tc1,x,tc1:GetLevel(),tc1:GetRank())
	mg:AddCard(tc2)
	c:SetMaterial(mg)
	local fg=mg:Filter(Card.IsFacedown,nil)
	if fg:GetCount()>0 then Duel.ConfirmCards(1-tp,fg) end
	Duel.Remove(mg,POS_FACEUP,REASON_MATERIAL+7150)
end
function ref.rfilter(c)
	return c:IsPreviousLocation(LOCATION_REMOVED) and c:IsSetCard(0x785e) and bit.band(c:GetReason(),REASON_RETURN)==REASON_RETURN
end
function ref.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(ref.rfilter,1,nil)
end
function ref.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x785e) and c:IsAbleToRemove()
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function ref.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,ref.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
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
