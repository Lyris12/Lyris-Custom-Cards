--旋風のファイター
function c101010042.initial_effect(c)
c:EnableReviveLimit()
	--synchro summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(aux.SynCondition(nil,aux.NonTuner(nil),1,99))
	e0:SetTarget(aux.SynTarget(nil,aux.NonTuner(nil),1,99))
	e0:SetOperation(c101010042.synop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e1:SetValue(LOCATION_DECKSHF)
	c:RegisterEffect(e1)
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c101010042.atkval)
	c:RegisterEffect(e2)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101010042.detcon)
	e2:SetCost(c101010042.detcost)
	e2:SetTarget(c101010042.dettg)
	e2:SetOperation(c101010042.detop)
	c:RegisterEffect(e2)
end
function c101010042.detcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsContains(c)
end
function c101010042.detcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	local mg=c:GetMaterial()
	e:SetLabel(mg:GetCount())
	mg:KeepAlive()
	e:SetLabelObject(mg)
	Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
end
function c101010042.dettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,e:GetLabel(),tp,LOCATION_DECK)
end
function c101010042.detop(e,tp,eg,ep,ev,re,r,rp)
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
function c101010042.synop(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.SendtoDeck(g,nil,2,REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
end
function c101010042.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsAttribute,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,e:GetHandler(),ATTRIBUTE_WIND)*400
end
