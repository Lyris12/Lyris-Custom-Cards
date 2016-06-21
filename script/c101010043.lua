--旋風の宝玉－ダイヤモンド・シンクロ・ドラゴン
local id,ref=GIR()
function ref.start(c)
c:EnableReviveLimit()
	--synchro summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(aux.SynCondition(nil,aux.NonTuner(Card.IsType,TYPE_SYNCHRO),1,99))
	e0:SetTarget(aux.SynTarget(nil,aux.NonTuner(Card.IsType,TYPE_SYNCHRO),1,99))
	e0:SetOperation(ref.synop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	--summon-to deck
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,id)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO end)
	e3:SetTarget(ref.tdtg)
	e3:SetOperation(ref.tdop)
	c:RegisterEffect(e3)
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(ref.detcon)
	e2:SetCost(ref.detcost)
	e2:SetTarget(ref.dettg)
	e2:SetOperation(ref.detop)
	c:RegisterEffect(e2)
end
function ref.detcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsContains(c)
end
function ref.detcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	local mg=c:GetMaterial()
	e:SetLabel(mg:GetCount())
	mg:KeepAlive()
	e:SetLabelObject(mg)
	Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
end
function ref.dettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,e:GetLabel(),tp,LOCATION_DECK)
end
function ref.detop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=e:GetLabelObject()
	local mct=mg:GetCount()
	if mct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>mct then
		local g=Group.CreateGroup()
		local mat=mg:GetFirst()
		while mat do
			local g1=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK+LOCATION_EXTRA,0,e:GetHandler(),mat:GetCode())
			g:Merge(g1)
			mat=mg:GetNext()
		end
		if g:GetCount()>0 then
			local sg=Group.CreateGroup()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local rc=nil
			for i=1,mct do
				rc=g:FilterSelect(tp,Card.IsCanBeSpecialSummoned,1,1,c,e,0,tp,false,false)
				sg:AddCard(rc:GetFirst())
				g:Remove(Card.IsCode,nil,rc:GetFirst():GetCode())
				if g:GetCount()==0 then break end
			end
			local tc=sg:GetFirst()
			while tc do
				Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetValue(1)
				tc:RegisterEffect(e1)
				tc=sg:GetNext()
			end
			Duel.SpecialSummonComplete()
		end
	end
end
function ref.synop(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.SendtoDeck(g,nil,2,REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
end
function ref.cfilter(c,e,n)
	if c:IsImmuneToEffect(e) then return end
	if n~=0 then return c:IsRankBelow(5)
	else return c:IsLevelAbove(5) end
end
function ref.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),e,0)
	or Duel.IsExistingMatchingCard(ref.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,1) end
	local g=Group.CreateGroup()
	if Duel.IsExistingMatchingCard(ref.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),e,0) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tc1=Duel.SelectMatchingCard(tp,ref.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler(),e,0)
		g:AddCard(tc1:GetFirst())
	end
	if Duel.IsExistingMatchingCard(ref.cfilter,rp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,1) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tc2=Duel.SelectMatchingCard(tp,ref.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,1)
		g:AddCard(tc2:GetFirst())
	end
	local tc=g:GetFirst()
	while tc do
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_DISABLE)
		e0:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e0)
		local dis=e0:Clone()
		dis:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(dis)
		Duel.SetTargetCard(tc)
		tc=g:GetNext()
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function ref.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
		local dg=Duel.GetOperatedGroup()
		local atk=0
		local dc=dg:GetFirst()
		while dc do
			if dc:GetBaseAttack()>0 then atk=atk+dc:GetBaseAttack() end
			dc=dg:GetNext()
		end
		if atk>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetValue(atk)
			c:RegisterEffect(e1)
		end
	end
end