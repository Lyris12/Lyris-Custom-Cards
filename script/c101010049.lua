--created & coded by Lyris
--サイバー・ドラゴン・メイ
function c101010049.initial_effect(c)
c:EnableReviveLimit()
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsCode,70095154),5,2,nil,nil,5)
	--detach
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c101010049.rmcon)
	e3:SetOperation(c101010049.rmop)
	c:RegisterEffect(e3)
	--cannot fuse
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e5)
	--release from xyz
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101010049.detcon)
	e2:SetOperation(c101010049.detop)
	c:RegisterEffect(e2)
	--indes
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(c101010049.efilter)
	c:RegisterEffect(e6)
	--You can return all banished Machine-Type monsters to the graveyard; Special Summon 1 Machine-Type monster from your Deck or Extra Deck whose Level/Rank is equal to or less than the number of cards returned, ignoring the Summoning conditions. This card must have an Xyz Material(s) attached to it to activate and resolve this effect.
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetLabel(0)
	e7:SetCondition(c101010049.con)
	e7:SetCost(c101010049.cost)
	e7:SetTarget(c101010049.tg)
	e7:SetOperation(c101010049.op)
	c:RegisterEffect(e7)
end
function c101010049.detcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return g:IsContains(e:GetHandler())
end
function c101010049.detop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetOverlayGroup()
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c101010049.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c101010049.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetOverlayCount()>0 then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
end
function c101010049.efilter(e,re,rp)
	if not re:IsActiveType(TYPE_TRAP) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g:IsContains(e:GetHandler())
end
function c101010049.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()~=0
end
function c101010049.cfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsFaceup()
end
function c101010049.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010049.cfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	local ct=Duel.GetMatchingGroupCount(c101010049.cfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	e:SetLabel(ct)
	local g=Duel.GetMatchingGroup(c101010049.cfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_RETURN)
end
function c101010049.filter(c,e,tp,lv)
	return c:IsRace(RACE_MACHINE) and (c:IsLevelBelow(lv) or c:IsRankBelow(lv)) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c101010049.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local lv=e:GetLabel()
	local g=Duel.GetMatchingGroup(c101010049.filter,tp,LOCATION_EXTRA+LOCATION_DECK,0,nil,e,tp,lv)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_EXTRA+LOCATION_DECK)
end
function c101010049.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetOverlayCount()==0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	local g=Duel.GetMatchingGroup(c101010049.filter,tp,LOCATION_EXTRA+LOCATION_DECK,0,nil,e,tp,lv)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		if Duel.SelectYesNo(tp,aux.Stringid(101010049,0)) then
			tc:CompleteProcedure()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
			e1:SetTargetRange(1,0)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
